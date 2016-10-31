
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
  p("The Portfolio Manager here randomly picks an assigned number of stocks and
    tries hard to beat the S&P 500 Total Return Index. Your job is to let him 
    know how hard he can try and for how long he can play"),
  p(strong("The nice thing about this manager: He doesn't charge you for extra work!")),

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
                   c("Buy and Hold (Lazy)" = "none",
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
