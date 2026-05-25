# Shiny App User Interface for Injury data exploration
app_ui <- function() {

  # Create main application page
  shiny::fluidPage(
    shiny::titlePanel("Exploring ER Injuries Data"),

    # Create tabbed Navigation layout
    shiny::tabsetPanel(

      # Variable Summaries
      shiny::tabPanel(
        "Summaries",
        shiny::sidebarLayout(
          shiny::sidebarPanel(
            shiny::selectInput(
              "var",
              "Choose variable:",
              choices = NULL
            )
          ),
          # Main Panel outputs
          shiny::mainPanel(


            # Interactive graphical summary
            shiny::h3("Graphical Summary"),
            plotly::plotlyOutput("summary_plot"),

            # Numerical statistical summary
            shiny::h3("Numerical Summary"),
            shiny::verbatimTextOutput("summary_text"),

            # Frequency table display
            shiny::h3("Frequency Table"),
            DT::DTOutput("freq_table")
          )
        )
      ),

      # Patient narrative by body parts
      shiny::tabPanel(
        "Patient Narratives",
        shiny::sidebarLayout(

          # Sidebar body part selector
          shiny::sidebarPanel(
            shiny::selectInput(
              "body",
              "Choose body part:",
              choices = NULL
            )
          ),

          # Display matching patient narratives
          shiny::mainPanel(
            shiny::h3("Related Patient Narratives"),
            DT::DTOutput("narratives")
          )
        )
      ),

      # Extra exploration by injury location
      shiny::tabPanel(
        "Extra: Injury Location",
        shiny::sidebarLayout(

          # Sidebar location selector
          shiny::sidebarPanel(

            shiny::selectInput(
              "location",
              "Choose injury location:",
              choices = NULL
            )
          ),

          # Display plots and tables for selected variables
          shiny::mainPanel(
            shiny::h3("Most Common Body Parts by Location"),
            plotly::plotlyOutput("location_plot"),

            shiny::h3("Cases from Selected Location"),
            DT::DTOutput("location_table")
          )
        )
      )
    )
  )
}
