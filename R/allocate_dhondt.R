#' Function to allocate seats to parties using the \href{http://www.europarl.europa.eu/unitedkingdom/en/european-elections/european_elections/the_voting_system.html}{D'Hondt method} of proportional representation
#'
#' @param .votes numeric vector, named with Parties, containing the votes or proportion of vote for each Party
#' @param .max_seats numeric vector, named with Parties, containing the maximum number of seats a Party can win (e.g. 1 for independent candidates)
#' @param .num_of_seats integer being the number of seats to allocate to the Parties provided
#'
#' @return a named numeric vector, detailing the number of seats allocated to each Party
#'
#' @examples
#' 
#' set.seed(4)
#' 
#' votes <- setNames(c(50000, runif(9, 0, 10000)), LETTERS[1:10])
#' 
#' num_seats <- 8
#' 
#' max_seats <- setNames(c(1, rep(num_seats, 9)), LETTERS[1:10])
#' 
#' allocate_dhondt(votes, max_seats, num_seats)

allocate_dhondt <- function(.votes, .max_seats, .num_of_seats) {
  
  seats <- replace(.votes, TRUE, 0)
  
  for (seat in 1:.num_of_seats){
    
    lead <- names(sort(-(.votes[seats < .max_seats] / (seats[seats < .max_seats] + 1)))[1])
    
    seats[lead] <- seats[lead] + 1
    
  }
  
  seats <- seats[seats > 0]
  
  return(seats)
  
}

