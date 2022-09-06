use pyo3::prelude::*;
use std::ffi::CString;
use std::os::raw::c_char;

#[pyfunction]
fn go_echo(message: String) -> PyResult<()> {
    let message = CString::new(message)?;
    unsafe {
        golib_binding::echo(message.as_ptr() as *mut c_char);
    }
    Ok(())
}

pub fn register_golib(py: Python, m: &PyModule) -> PyResult<()> {
    let golib = PyModule::new(py, "golib")?;
    m.add_submodule(golib)?;
    golib.add_wrapped(wrap_pyfunction!(go_echo))?;
    Ok(())
}
