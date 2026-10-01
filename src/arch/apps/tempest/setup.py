#!/usr/bin/env python3

from setuptools import setup # type: ignore

setup(name='tempest',
      version='0.0.1',
      description='Temporal Planner via Encoding into Satisfiability Testing',
      author='FBK PSO Unit',
      author_email='tamer@fbk.eu',
      packages=['tempest', 'tempest.encoders'],
      python_requires='>=3.10',
      # Pinned to a known-good commit: base_encoder.py relies on `pysmt.optimization.goal`'s
      # import chain having the side effect of loading `pysmt.solvers` (used in a type
      # annotation as `pysmt.solvers.solver.Model`). Unpinned, pip pulls pysmt's current
      # default-branch HEAD, which may no longer have that side effect and breaks the import
      # with `AttributeError: module 'pysmt' has no attribute 'solvers'`.
      install_requires=["pysmt @ git+https://github.com/pysmt/pysmt@4a59e6a75f151a2cc29cbbfa47fa2934324a4607"],
      license="LGPLv3",
      classifiers=["License :: GNU Lesser General Public License v3.0"],
)
