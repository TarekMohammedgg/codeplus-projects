/// New average after adding [newRating] to [count] existing ratings
/// whose average is [average].
double nextAverage(double average, int count, int newRating) =>
    ((average * count) + newRating) / (count + 1);
