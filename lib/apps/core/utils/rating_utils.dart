double nextAverage(double average, int count, int newRating) =>
    ((average * count) + newRating) / (count + 1);
