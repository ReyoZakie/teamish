class Solution {
  List<int> maximumBeauty(List<List<int>> items, List<int> queries) {
    List<int> answer = [0];
    int beauty = 0;

    for (int i = 0; i < items.length - 1; i++) {
      for (int j = 0; j < items.length - 1; j++) {
        if (queries[i] >= items[0][j]) {
          if (beauty < items[1][j]) {
            beauty = items[1][j];
            answer.add(items[1][j]);
          }
        }
      }
    }
    return answer;
  }
}
