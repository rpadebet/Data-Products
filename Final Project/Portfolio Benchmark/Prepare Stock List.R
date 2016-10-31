loadTickerUniverse <- function(){
    File <- "./DowJones Components.csv"
    company_data<-read.csv(file =File,stringsAsFactors = F,header = T ) 
    return(company_data)
}


