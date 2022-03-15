#' Return a Data Frame Containing Simulation Results
#'
#' This function creates a data frame containing the time histories
#' of any model outputs that were included on the prepare list (i.e.,
#' logged) as of the last simulation run.  The magnoliaResults function
#' is provided as an alternative to collecting time histories one
#' at a time using the history() method of the model object.
#'
#' Note that the model needs to have had ouputs flagged for logging
#' using the prepare() method, and the model needs to have been executed
#' for any results to be available.
#'
#' @param mdl A model object created using the magnoliaBuild() function
#' @return An Data Frame containing simulation results
magnoliaResults <- function(mdl)
{
    res = NULL

    nvars <- mdl$prepareNameList$size()
    for(i in seq(0, nvars - 1))
    {
        vname <- mdl$prepareNameList$get(i)
        hist <- mdl$history(vname);

        #tmp <- data.frame(hist)
        #names(tmp) <- c(vname)
        tmp <- matrix(hist)
        colnames(tmp) <- c(vname)

        res <- cbind(res, tmp)
    }

    return(as.data.frame(res))
}

