
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Monkey Capital Management LLC"),
  h2("Can a Monkey beat the S&P 500?"),
  p("The Portfolio Manager here picks an assigned number of stocks once
    and never thinks about it again, as he uses a highly sophisticated 
    RANDOM stock picking strategy.(For now he is limited to the Dow 30 names given his IQ)"),
  p("He wants to show you he is working though, so he tries hard to beat the 
    S&P 500 Total Return Index every day."),
  p("Your job is to let him know how hard he can work and for how long he can play"),
  p(strong("The nicest thing about this manager: He doesn't charge you for extra work!")),
  p("He also makes his TOP STOCK PICKS and Performance data readily available for all to see"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("picks",
                  "How many picks does the Monkey get?",
                  min = 1,
                  max = 10,
                  value = 4),
      sliderInput("years",
                  "How many years can the Monkey play?",
                  min = 1,
                  max = 15,
                  value = 5),
      radioButtons("rebal",
                   "How hard do you want the Monkey to work?",
                   c(
                     "Rebalances Daily" = "days",
                     "Rebalances Weekly" = "weeks",
                     "Rebalances Monthly" = "months",
                     "Rebalances Quarterly" = "quarters",
                     "Rebalances Yearly" = "years"
                     ),
                   selected ="months" ),
      actionButton("load","Let's Play")
      
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
            tabPanel("Monkey Portfolio Value",
                plotOutput("moneyPlot")
                
            ),
            tabPanel("Monkey Portfolio Comparison",
                plotOutput("perfPlot")
                
            ),
            tabPanel("Performance Data",
                tableOutput("perfTable")
            ),
            tabPanel("Top Stock Picks",
                tableOutput("stocks")
            )
        )
  
    )
  )
))
