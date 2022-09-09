use pyo3::prelude::*;

mod golib;

#[pyfunction]
fn rust_echo(message: String) -> PyResult<()> {
    println!("Rust:> {}", message);
    Ok(())
}

#[pymodule]
fn pyo3_pkg(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_wrapped(wrap_pyfunction!(rust_echo)).unwrap();
    golib::register_golib(_py, m)?;
    Ok(())
}

#[cfg(test)]
mod test {
    #[test]
    fn test_dummy() {
        assert_eq!(1, 1);
    }
}
