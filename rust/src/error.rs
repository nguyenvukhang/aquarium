use std::env;
use std::fmt;
use std::io;
use std::time;

#[derive(Debug)]
pub enum Error {
    IoErr(io::Error),
    ReqwestErr(reqwest::Error),
    JSONParseError,
    VarErr(env::VarError),
    TimeErr(time::SystemTimeError),
    // SerdeJsonErr(serde_json::Error),
}

pub type Result<T> = std::result::Result<T, Error>;

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use Error::*;
        match self {
            IoErr(e) => write!(f, "{e:?}"),
            ReqwestErr(e) => write!(f, "{e:?}"),
            JSONParseError => write!(f, "Unable to parse json value."),
            TimeErr(e) => write!(f, "{e:?}"),
            VarErr(e) => write!(f, "{e:?}"),
            // SerdeJsonErr(e) => write!(f, "{e:?}"),
        }
    }
}

#[rustfmt::skip]
impl From<io::Error>for Error{fn from(v:io::Error)->Self{Self::IoErr(v)}}
#[rustfmt::skip]
impl From<reqwest::Error>for Error{fn from(v:reqwest::Error)->Self{Self::ReqwestErr(v)}}
#[rustfmt::skip]
impl From<env::VarError>for Error{fn from(v:env::VarError)->Self{Self::VarErr(v)}}
#[rustfmt::skip]
impl From<time::SystemTimeError>for Error{fn from(v:time::SystemTimeError)->Self{Self::TimeErr(v)}}
// #[rustfmt::skip]
// impl From<serde_json::Error>for Error{fn from(v:serde_json::Error)->Self{Self::SerdeJsonErr(v)}}
