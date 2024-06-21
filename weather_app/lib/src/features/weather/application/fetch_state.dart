  /// Initial state of not fetched
  enum FetchState {
  not_fetched,

  /// Currently fetching or loading
  fetching,

  /// Done fetching and loaded data successfully
  done,

  /// Received an error while fetching
  errored
}
