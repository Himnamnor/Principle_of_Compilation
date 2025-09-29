#!/bin/bash
# compare_txt.sh file1 file2
if [ $# -ne 2 ]; then
  echo "Usage: $0 file1 file2"
  exit 1
fi

# 使用cmp按字节比对
if cmp -s "$1" "$2"; then
  echo "完全一致"
else
  echo "存在差异"
  # 输出具体差异位置（行列）
  diff -u --label "$1" --label "$2" "$1" "$2"
fi
