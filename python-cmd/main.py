from pythonlib import vector, rust_echo, golib

def main():
    rust_echo("Hello from Python!")
    golib.go_echo("Hello from Python!")
    print("Call internal another package: ", vector.create_vector([1, 2, 3]))

if __name__ == "__main__":
    main()
