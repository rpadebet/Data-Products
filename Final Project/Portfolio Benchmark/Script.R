# Load Libraries
suppressPackageStartupMessages(require(quantmod))
suppressPackageStartupMessages(require(PerformanceAnalytics))
suppressPackageStartupMessages(require(plyr))
suppressPackageStartupMessages(require(lubridate))

# Prepare the Universe of companies
File <- "../DowJones Components.csv"
company<-read.csv(file =File,stringsAsFactors = F,header = T )

#Select 5 random companies
tickers = sample(company$Ticker.Symbol,5)
company.name = company[company$Ticker.Symbol %in% tickers,2]

# Getting the Data from Yahoo
benchmark_ticker<-c('^SP500TR')
data.env <- new.env()
options("getSymbols.warning4.0"=FALSE)
l_ply(tickers, function(sym) try(getSymbols(sym,env=data.env),silent=T))
benchmark_data<-getSymbols(benchmark_ticker,env=data.env)
tickers <- tickers[tickers %in% ls(data.env)]

# Cleaning and Arranging the Data from Yahoo to use Adjusted Price
prices <- xts()
for(i in seq_along(tickers)) {
    symbol <- tickers[i]
    prices <- merge(prices, Ad(get(symbol,envir=data.env)))
}

benchmark_prices<- Ad(get(benchmark_data,data.env))
n = length(tickers)

#Equal Weight portfolio
years <- 5
StartDate<-ymd(Sys.Date())-years(years)
Weights<- xts(matrix(rep(1 / n, n), 1), StartDate)
colnames(Weights)<-colnames(prices)

# Subsetting data from StartDate
prices_sub<-prices[index(prices)>=StartDate]
benchmark_prices_sub<-benchmark_prices[index(prices)>=StartDate]


# Calculating Returns
returns<-Return.calculate(prices_sub)
returns<-returns[-1,] #remove the first row
returns<-as.xts(returns)
indexClass(returns)<-"Date"

benchmark_returns<-Return.calculate(benchmark_prices_sub)
benchmark_returns<-benchmark_returns[-1,]


# Portfolio Analytics
portfolio_rebal<-Return.portfolio(returns,rebalance_on = "quarters",
                            wealth.index = TRUE, verbose = TRUE)
portfolio_buyhold<-Return.portfolio(returns,Weights,rebalance_on = "none",
                                  wealth.index = TRUE, verbose = TRUE)
benchmark_portfolio<-Return.portfolio(benchmark_returns, wealth.index = TRUE,verbose = TRUE)

# Preparing data for Charts
plot_data<-merge.xts(portfolio_rebal$returns,portfolio_buyhold$returns,benchmark_portfolio$returns)
names(plot_data)<-c("Rebalanced Portfolio","BuyHold Portfolio","Benchmark")








