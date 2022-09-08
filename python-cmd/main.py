import pyo3_pkg
from pythonlib import vector

def main():
    pyo3_pkg.rust_echo("Hello from Python!")
    pyo3_pkg.golib.go_echo("Hello from Python!")
    print("Call internal another package: ", vector.create_vector([1, 2, 3]))

if __name__ == "__main__":
    main()
