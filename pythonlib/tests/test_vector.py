from pathlib import Path

import numpy as np


def test_create_vector():
    from pythonlib.vector import create_vector

    v = [1, 2, 3]
    assert np.array_equal(create_vector(v), np.array([1, 2, 3]))
