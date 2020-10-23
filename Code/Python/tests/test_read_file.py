import read_file
import pytest
import numpy as np 

def test_file_load_good():
    # test if function returns numpy array for good input file.
    data = read_file.read_file("input_good.inp")
    assert type(data) == np.ndarray

def test_file_load_bad():
    # Test if the function raises the exception if nonexisting file name is passed as parameter.
    with pytest.raises(ValueError) as excinfo:
        read_file.read_file("input_bad.inp")

    assert "enough rows in input file" in str(excinfo.value)

def test_file_load_missing_file():
    # Test if the function raises the exception if nonexisting file name is passed as parameter.
    with pytest.raises(ValueError) as excinfo:
        read_file.read_file("non-existing_file.txt")

    assert "file does not exist" in str(excinfo.value)