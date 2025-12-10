#! /bin/sh
set -e

unzip seqan.zip 

tar -xvf sdsl-lite.tar.gz
cd sdsl-lite
if [ "$(uname)" = "Darwin" ]; then
  find . -name "CMakeLists.txt" -type f -exec gsed -i 's/cmake_minimum_required.*$/cmake_minimum_required(VERSION 3.5)/g' {} \;
  # Fix louds_tree.hpp bug: m_select1/m_select0 should be m_bv_select1/m_bv_select0
  gsed -i 's/tree\.m_select1/tree.m_bv_select1/g' include/sdsl/louds_tree.hpp
  gsed -i 's/tree\.m_select0/tree.m_bv_select0/g' include/sdsl/louds_tree.hpp
else
  find . -name "CMakeLists.txt" -type f -exec sed -i 's/cmake_minimum_required.*$/cmake_minimum_required(VERSION 3.5)/g' {} \;
  # Fix louds_tree.hpp bug: m_select1/m_select0 should be m_bv_select1/m_bv_select0
  sed -i 's/tree\.m_select1/tree.m_bv_select1/g' include/sdsl/louds_tree.hpp
  sed -i 's/tree\.m_select0/tree.m_bv_select0/g' include/sdsl/louds_tree.hpp
fi

./install.sh "$(pwd)"/libsdsl

sed -i '/template <size_t PAGESIZE>/i\ #ifdef PAGESIZE\n#undef PAGESIZE\n#endif' ./seqan/file/file_page.h