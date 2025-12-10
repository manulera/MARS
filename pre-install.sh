#! /bin/sh
set -e

# Use gsed on macOS, sed on other platforms
if [ "$(uname)" = "Darwin" ]; then
  alias sed='gsed'
else
  alias sed='sed'
fi

# https://github.com/lorrainea/MARS/issues/20
unzip seqan.zip
sed -i '/template <size_t PAGESIZE>/i\ #ifdef PAGESIZE\n#undef PAGESIZE\n#endif' ./seqan/file/file_page.h

tar -xvf sdsl-lite.tar.gz
cd sdsl-lite

# Change cmake minimum required version to 3.5, failing in new versions of alpine
find . -name "CMakeLists.txt" -type f -exec sed -i 's/cmake_minimum_required.*$/cmake_minimum_required(VERSION 3.5)/g' {} \;

# Fix louds_tree.hpp bug: m_select1/m_select0 should be m_bv_select1/m_bv_select0
sed -i 's/tree\.m_select1/tree.m_bv_select1/g' include/sdsl/louds_tree.hpp
sed -i 's/tree\.m_select0/tree.m_bv_select0/g' include/sdsl/louds_tree.hpp

./install.sh "$(pwd)"/libsdsl

mv libsdsl/ ..
