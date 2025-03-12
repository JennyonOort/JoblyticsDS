library(shiny)
library(tidyverse)
library(plotly)
library(ggplot2)
library(DT)
library(shinydashboard)
library(wordcloud2)

# Load and preprocess data
jobs_data <- read_csv("../data/processed/data_analyst_can_clean.csv") %>%
  mutate(
    salary_min = as.numeric(gsub(",", "", Min_Salary)),
    salary_max = as.numeric(gsub(",", "", Max_Salary)),
    salary_avg = as.numeric(gsub(",", "", Avg_Salary))
  )

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Data Analyst Jobs in Canada", titleWidth = "100%"),
  dashboardSidebar(
    selectInput("province", "Select Province:",
                choices = c("All", unique(jobs_data$Province)),
                multiple = TRUE,
                selected = "All"),
    checkboxGroupInput("work_type", "Employment Type:",
                      choices = unique(jobs_data$`Work Type`),
                      selected = unique(jobs_data$`Work Type`)),
    selectInput("industry", "Select Industry Type:",
                choices = c("All", unique(jobs_data$`Industry Type`)),
                multiple = TRUE,
                selected = "All"),
    actionButton("update", "Update Selection", class = "btn-green")
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        body, label, input, button, select { 
          font-family: 'Georgia'; 
        }
        .main-header .logo {
          font-family: 'Montserrat';  /* Change font for the logo */
          font-size: 28px;  /* Adjust font size for the header title */
          width: 100%;  /* Ensure the title spans the full width */
          text-align: left;  /* Left align the title */
        }
        .box {
          border-top: 3px solid #3c8dbc;
        }
        .box-header {
          background-color: #3c8dbc;
          color: white;
        }
        .box-body {
          font-family: 'Georgia';
        }
        .btn-green {
          background-color: green;
          color: white;
          border: none;
        }
        .btn-green:hover {
          background-color: darkgreen;
        }
      "))
    ),
    tabBox(
      id = "tabset1", height = "100%", width = 12,
      tabPanel("Dashboard",
        fluidRow(
          box(plotlyOutput("skills_plot", height = "600px"), width = 6),
          box(plotlyOutput("salary_plot", height = "600px"), width = 6)
        )
      ),
      tabPanel("Table",
        fluidRow(
          box(DTOutput("jobs_table"), width = 12)
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  filtered_data <- eventReactive(input$update, {
    data <- jobs_data
    if (!("All" %in% input$province)) {
      data <- data %>% filter(Province %in% input$province)
    }
    if (!("All" %in% input$industry)) {
      data <- data %>% filter(`Industry Type` %in% input$industry)
    }
    data <- data %>% filter(`Work Type` %in% input$work_type)
    data
  }, ignoreNULL = FALSE)
  
  observeEvent(input$update, {
    # Skills Ranked by Count
    output$skills_plot <- renderPlotly({
      skills <- unlist(strsplit(paste(filtered_data()$Skill, collapse = ", "), ", "))
      skills_df <- as.data.frame(table(skills)) %>%
        filter(Freq > 0) %>%
        arrange(desc(Freq)) %>%
        head(nrow(filtered_data() %>% group_by(Position) %>% summarise(count = n())))
            
      plot_ly(skills_df, x = ~Freq, y = ~reorder(skills, Freq), type = 'bar', orientation = 'h', name = 'Skills') %>%
        layout(title = list(text = "<b>Top Skills For Positions by Count</b>"),
              xaxis = list(title = "Count"),
              yaxis = list(title = "Skills"),
              font = list(family = "Georgia")
              )
    })
    
    # Average Salary by Position
    output$salary_plot <- renderPlotly({
      
      salary_data <- filtered_data() %>%
        group_by(Position) %>%
        summarise(min_salary = min(salary_min, na.rm = TRUE),
                  avg_salary = mean(salary_avg, na.rm = TRUE),
                  max_salary = max(salary_max, na.rm = TRUE)) %>%
        arrange(desc(avg_salary))
      
      ggplot(salary_data, aes(x = avg_salary, y = reorder(Position, avg_salary))) +
        geom_point(aes(color = "Average Salary"), size = 2) +  # Average Salary as points
        geom_errorbarh(aes(xmin = min_salary, xmax = max_salary), height = 1) +  # Min and Max as error bars
        labs(title = "Salary by Position (Min, Avg, Max)",
            x = "Salary (CAD)",
            y = "Position") +
        scale_color_manual(name = "Legend", values = c("Average Salary" = "blue")) +
        theme_minimal() +
        theme(legend.position = "none",  # Hide `legend`
              plot.title = element_text(face = "bold", family = "Georgia"), 
              axis.title = element_text(family = "Georgia"), 
              axis.text = element_text(family = "Georgia")
        )
    })

    # Jobs table
    output$jobs_table <- renderDT({
      data <- filtered_data()
      
      # Return the filtered data to render the table
      data %>%
        select(`Job Title`, Employer, City, Province, `Min_Salary`, `Max_Salary`, `Avg_Salary`, `Work Type`, `Industry Type`) %>%
        datatable(
          options = list(
            pageLength = 5, 
            autoWidth = TRUE, 
            scrollX = TRUE,
            columnDefs = list(
              list(className = 'dt-center', targets = c(0, 1, 2, 3, 7, 8)),  # Left align for categorical columns
              list(className = 'dt-right', targets = c(4, 5, 6))               # Right align for numerical columns
            ),
            dom = 'lfrtip',  # 'lfrtip' ensures the search box is at the top (filtering + info + pagination + table)
            initComplete = JS(
              "function(settings, json) {",
              "  $(this.api().table().header()).css({'background-color': '#f1f1f1'});",  # Optional styling for header
              "}"),
            searchHighlight = TRUE  # Highlight search results
          ),
          filter = 'top',  # Enable filtering at the top of each column
          rownames = FALSE
        ) %>%
        formatStyle(
          c("Job Title", "Employer", "City", "Province", "Work Type", "Industry Type"),
          'text-align' = 'left'  # Ensure text is left aligned for categorical columns
        ) %>%
        formatCurrency(c("Min_Salary", "Max_Salary", "Avg_Salary"), currency = "CAD", digits = 0) %>%
        formatRound(c("Min_Salary", "Max_Salary", "Avg_Salary"), digits = 0)
    })
  }, ignoreNULL = FALSE)
  
  # Trigger the update button programmatically on initial load
  session$onFlushed(function() {
    isolate({
      updateActionButton(session, "update", label = "Update Selection")
    })
  }, once = TRUE)
}

# Run the app
shinyApp(ui = ui, server = server)