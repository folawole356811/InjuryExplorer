# Shiny App Server logic for injury data Exploration
app_server <- function(input, output, session) {

  # Load ER Injuries dataset from Mastering Shiny
  injuries <- vroom::vroom(
    "https://github.com/hadley/mastering-shiny/raw/main/neiss/injuries.tsv.gz",
    show_col_types = FALSE
  )

  #Populate dropdown menus after the data is loaded
  shiny::updateSelectInput(
    session,
    "var",
    choices = names(injuries),
    selected = "body_part"
  )

  shiny::updateSelectInput(
    session,
    "body",
    choices = sort(unique(injuries$body_part))
  )

  shiny::updateSelectInput(
    session,
    "location",
    choices = sort(unique(injuries$location))
  )

  # create graphical summary for selected variable
  output$summary_plot <- plotly::renderPlotly({

    shiny::req(input$var)

    x <- injuries[[input$var]]

    # Displayed numeric variables as histogram
    if (is.numeric(x)) {

      p <- ggplot2::ggplot(
        injuries,
        ggplot2::aes(x = .data[[input$var]])
      ) +
        ggplot2::geom_histogram(
          bins = 30,
          fill = "steelblue",
          color = "white"
        ) +
        ggplot2::labs(
          x = input$var,
          y = "Count"
        ) +
        ggplot2::theme_minimal()

    } else {

      # Displayed categorical variables as bar charts
      p <- injuries |>
        dplyr::count(.data[[input$var]], sort = TRUE) |>
        dplyr::slice_head(n = 20) |>
        ggplot2::ggplot(
          ggplot2::aes(
            x = reorder(as.factor(.data[[input$var]]), n),
            y = n
          )
        ) +
        ggplot2::geom_col(fill = "steelblue") +
        ggplot2::coord_flip() +
        ggplot2::labs(
          x = input$var,
          y = "Count"
        ) +
        ggplot2::theme_minimal()
    }

    plotly::ggplotly(p)
  })

  # Display numerical summary for selected variables
  output$summary_text <- shiny::renderPrint({

    shiny::req(input$var)

    summary(injuries[[input$var]])

  })

  # Display freqency table for selected variable
  output$freq_table <- DT::renderDT({

    shiny::req(input$var)

    injuries |>
      dplyr::count(.data[[input$var]], sort = TRUE) |>
      dplyr::rename(
        Category = 1,
        Count = n
      )

  })

  # Display patient narratives for selected body part
  output$narratives <- DT::renderDT({

    shiny::req(input$body)

    injuries |>
      dplyr::filter(body_part == input$body) |>
      dplyr::select(
        trmt_date,
        age,
        sex,
        race,
        body_part,
        diag,
        location,
        narrative
      )

  })

  # Plot most common injured body parts for selected variable
  output$location_plot <- plotly::renderPlotly({

    shiny::req(input$location)

    p <- injuries |>
      dplyr::filter(location == input$location) |>
      dplyr::count(body_part, sort = TRUE) |>
      dplyr::slice_head(n = 15) |>
      ggplot2::ggplot(
        ggplot2::aes(
          x = reorder(as.factor(body_part), n),
          y = n
        )
      ) +
      ggplot2::geom_col(fill = "darkorange") +
      ggplot2::coord_flip() +
      ggplot2::labs(
        x = "Body Part",
        y = "Number of Injuries",
        title = paste(
          "Most Common Body Parts Injured at",
          input$location
        )
      ) +
      ggplot2::theme_minimal()

    plotly::ggplotly(p)

  })

  # Display cases from the selected injury location
  output$location_table <- DT::renderDT({

    shiny::req(input$location)

    injuries |>
      dplyr::filter(location == input$location) |>
      dplyr::select(
        trmt_date,
        age,
        sex,
        race,
        body_part,
        diag,
        location,
        narrative
      )

  })
}
