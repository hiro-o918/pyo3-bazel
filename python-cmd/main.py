import pyo3_pkg

def main():
    pyo3_pkg.rust_echo("Hello from Python!")
    pyo3_pkg.golib.go_echo("Hello from Python!")

if __name__ == "__main__":
    main()
