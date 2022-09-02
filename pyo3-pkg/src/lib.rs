use pyo3::prelude::*;

#[pyfunction]
fn rust_echo(message: String) -> PyResult<()> {
    println!("{}", message);
    Ok(())
}

#[pymodule]
fn pyo3_pkg(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_wrapped(wrap_pyfunction!(rust_echo)).unwrap();
    Ok(())
}
