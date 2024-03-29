% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/group_icd_data_by_ver.R
\name{group_icd_data_by_ver}
\alias{group_icd_data_by_ver}
\title{Groups the data according to the ICD-versions}
\usage{
group_icd_data_by_ver(long_data)
}
\arguments{
\item{long_data}{A data.frame with at least column \code{ICD_VERSION}.}
}
\value{
A list(\code{groups}, \code{group_keys}, \code{group_idxs}):
\itemize{
\item \code{groups}: The grouped tibble.
\item \code{group_keys}: A list. The name of each group, so the
ICD-versions present in the data.
\item \code{group_idxs}: A named list. The indices of the
elements of each group in the original
\code{long_data}. The names are the group
names.
}
}
\description{
Groups the data.frame according to the ICD-versions, using
function \code{\link[dplyr]{group_by}}.
}
