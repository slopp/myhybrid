get_route <- function(start, end) {
  googlemaps <- import('googlemaps')
  os <- import('os')
  datetime <-  import('datetime')
  
  gmaps <- googlemaps$Client(key = os$environ$get('DIRECTIONS_API'))
  
  route <- gmaps$directions(start,
                                  end,
                                  mode = "driving", 
                                  departure_time  = datetime$datetime$now())
  return(route)
  
}