# 📈📊 JoblyticsDS

This Shiny dashboard provides interactive insights into the Canadian data analyst job market, including salary trends, in-demand skills, and detailed job listings by province and industry.

## 💡 Motivation
Target audience: Job seekers, data analysts, HR professionals, and researchers interested in the Canadian data analyst job market.

The demand for data analysts is rapidly increasing, with diverse industries seeking skilled professionals. However, finding the right opportunities and understanding the salary trends can be a challenge. This app aims to provide insights into the data analyst job market in Canada, helping users explore job listings, salary data, and essential job-related details. By filtering job listings based on location, industry, and employment type, users can identify opportunities and gain a better understanding of salary trends, skill requirements, and geographical distribution of data analyst jobs.

## 📖 App Description
This app presents an interactive dashboard to explore data analyst job listings across Canada. Key features include:

- **Salary Insights**: View average, minimum, and maximum salary data for data analyst positions by province and industry.
- **Skill Trends**: Visualize the most in-demand skills for data analyst roles.
- **Job Listings**: Explore a table of available job positions, with options to filter by province, industry, and employment type.
  
You can filter data by **Province**, **Industry Type**, and **Work Type** to tailor the insights to your specific interests and goals. The dashboard offers interactive charts and detailed tables for a comprehensive analysis of the job market.

## 📹 Video App Walkthrough
[VIDEO LINK TO BE ADDED]

## 🔢 Data Source

The dataset used in this app is sourced from [Kaggle](https://www.kaggle.com/datasets/amanbhattarai695/data-analyst-job-roles-in-canada). The dataset contains job listings for data analyst positions in Canada, including salary information and required skills for each job posting. The data has been preprocessed for use in this app.

## 💻 Installation Instructions

### Prerequisites:
To run this app locally, ensure you have the following installed:
- [R](https://cran.r-project.org/)
- [RStudio](https://posit.co/download/rstudio-desktop/)
- Required R libraries: `renv`, `shiny`, `tidyverse`, `plotly`, `ggplot2`, `shinydashboard`, `DT`, `wordcloud2`, `rsconnect`

### Steps to Install:

1. In `bash` terminal, clone the repository to your local machine:
   ```bash
   git clone https://github.ubc.ca/mds-2024-25/DSCI_532_individual-assignment_yuci21st.git
   cd DSCI_532_individual-assignment_yuci21st
   ```

2. Open RStudio and run the following command in the R console to install the required libraries (if not already installed):
    ```R
    install.packages(c("renv", "shiny", "tidyverse", "plotly", "ggplot2", "shinydashboard", "DT", "wordcloud2", "rsconnect"))
    ```

3. Navigate to the project folder and run the following R command in the console to restore the environment:
    ```R
    renv::restore()
    ```

4. Load the app by running the following command in RStudio:
    ```R
    shiny::runApp("app.R")
    ```

5. The app will launch locally in your default web browser. You can start interacting with the data and explore job market insights.

## 📚 License

The JoblyticsDS dashboard is licensed under the terms of the [MIT license and Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](./LICENSE.md).

## 🤜 Support

If you encounter any issues, require assistance, need to report a bug or request a feature, please file an issue through our [GitHub Issues](https://github.ubc.ca/mds-2024-25/DSCI_532_individual-assignment_yuci21st/issues).