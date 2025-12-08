#!/usr/bin/env python3

from setuptools import setup # type: ignore

setup(name='tempest',
      version='0.0.1',
      description='Temporal Planner via Encoding into Satisfiability Testing',
      author='FBK PSO Unit',
      author_email='tamer@fbk.eu',
      packages=['tempest', 'tempest.encoders'],
      python_requires='>=3.10',
      install_requires=["pysmt @ git+https://github.com/pysmt/pysmt"],
      license="LGPLv3",
      classifiers=["License :: GNU Lesser General Public License v3.0"],
)
