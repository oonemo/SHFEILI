"""Backend python package configuration."""

from setuptools import setup

setup(
    name='backend',
    version='0.1.0',
    packages=['backend'],
    include_package_data=True,
    install_requires=[
        'Flask==1.0.2',
        'pycodestyle==2.3.1',
        'pydocstyle==2.0.0',
        'pylint==1.8.1',
        'redis==2.10.5',
    ],
)