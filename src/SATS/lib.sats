#define ATS_PACKNAME "ats-pthread-extensions"
staload "libats/SATS/athread.sats"

fun{}
athread_create_funenv_join
  {env:vtype}
(
  tid: &tid? >> _
, fwork: (env) -> void, env: env
) : int(*err*)

fun{}
athread_create_cloptr_join_exn
  (fwork: ((*void*)) -<lincloptr1> void): lint(*tid*)
fun{}
athread_join
  (tid: lint): void(*tid*)
