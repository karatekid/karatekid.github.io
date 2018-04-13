dot_files=$(find dot_graphs -name '*.dot')

for dot in $dot_files; do
  dot_decoupled=${dot#dot_graphs/};
  mkdir -p $(dirname $dot_decoupled);
  dot -Tpng $dot -oassets/img/${dot_decoupled%.dot}.png;
done
