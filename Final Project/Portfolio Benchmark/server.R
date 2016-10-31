
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(quantmod)
require(PerformanceAnalytics)
require(plyr)
require(lubridate)

shinyServer(function(input, output) {

    observeEvent(input$load,
    {
            #Get User Input
            picks    <- input$picks
            years    <- input$years
            rebal    <- input$rebal
            
            # Load the ticker and file
            File <- "./DowJones Components.csv"
            company<-read.csv(file =File,stringsAsFactors = F,header = T )
            tickers = sample(company$Ticker.Symbol,picks)
            company.name = company[company$Ticker.Symbol %in% tickers,]
            benchmark_ticker<-c('^GSPC')
            
            # Download the prices data from Yahoo
            data.env <- new.env()
            l_ply(tickers, function(sym) try(getSymbols(sym,env=data.env),silent=T))
            benchmark_data<-getSymbols(benchmark_ticker,env=data.env)
            tickers <- tickers[tickers %in% ls(data.env)]
            
            prices <- xts()
            for(i in seq_along(tickers)) {
                symbol <- tickers[i]
                prices <- merge(prices, Ad(get(symbol,envir=data.env)))
            }
            benchmark_prices<- Ad(get(benchmark_data,data.env))
            
            #Preparing the price data
            n = length(tickers)
            StartDate<-ymd(Sys.Date())-years(years)
            Weights<- xts(matrix(rep(1 / n, n), 1), StartDate)
            colnames(Weights)<-colnames(prices)
        
            prices_sub<-prices[index(prices)>=StartDate]
            benchmark_prices_sub<-benchmark_prices[index(prices)>=StartDate]
            
            #Calculating the Return data
            returns<-Return.calculate(prices_sub)
            returns<-returns[-1,] #remove the first row
            returns<-as.xts(returns)
            indexClass(returns)<-"Date"
            
            benchmark_returns<-Return.calculate(benchmark_prices_sub)
            benchmark_returns<-benchmark_returns[-1,]
            
            # Calculating Portfolio Analytics
            portfolio_rebal<-Return.portfolio(returns,
                                              rebalance_on = rebal
                                              ,verbose = T,wealth.index = T)
            portfolio_buyhold<-Return.portfolio(returns,verbose=T,
                                                wealth.index = T)
            benchmark_portfolio<-Return.portfolio(benchmark_returns,verbose=T,
                                                  wealth.index = T)
            
            # Preparing Plot data
            plot_data<-merge.xts(portfolio_rebal$returns,portfolio_buyhold$returns,benchmark_portfolio$returns)
            
            names(plot_data)<-c("Rebalanced Portfolio","BuyHold Portfolio","Benchmark")
            
     
    
    # Plotting the data
    output$perfPlot <- renderPlot({
        charts.PerformanceSummary(plot_data,colorset=rainbow6equal,lwd=2)
    })

    
    output$perfTable <-renderTable({
        perf_return = xts()
        perf_return$rebal<-monthlyReturn(portfolio_rebal$wealthindex,type = 'arithmetic'
                                         ,leading = TRUE)
        perf_return$bh<-monthlyReturn(portfolio_buyhold$wealthindex,type = 'arithmetic'
                                      ,leading = TRUE)
        perf_return$bmk<-monthlyReturn(benchmark_portfolio$wealthindex,type = 'arithmetic'
                                       ,leading = TRUE)
        names(perf_return)<-c("Rebalanced Portfolio","BuyHold Portfolio","Benchmark")
        
        t(table.CalendarReturns(perf_return))
    },striped = T,bordered = T,rownames = T,colnames = T,na = "--",)
    
    output$stocks <-renderTable({
        company.name
    },bordered = T,striped = T)
    
    output$moneyPlot<-renderPlot({
        chartSeries(portfolio_rebal$wealthindex*100,name = "Value of Initial $100 Portfolio")
    })
    
 }) 

})
