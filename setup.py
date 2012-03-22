from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(ext_modules=[Extension("sudoku",["sudoku.pyx"],language="c++",libraries=["cryptominisat"])],cmdclass={"build_ext":build_ext})
