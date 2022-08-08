enum FetchState {
  /// Initial state of not fetched
  not_fetched,

  /// Currently fetching or loading
  fetching,

  /// Done fetching and loaded data successfully
  done,

  /// Received an error while fetching
  errored
}
