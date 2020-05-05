#include "./../HATS/includes.hats"
#define ATS_DYNLOADFLAG 0

%{#
//
#include <pthread.h>
//
%} // end of [%{^]

(* ****** ****** *)

staload
UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "libats/SATS/athread.sats"


abst@ype pthread_t = $extype"pthread_t"
abst@ype pthread_attr_t = $extype"pthread_attr_t"

(* ****** ****** *)
implement
{}(*tmp*)
athread_create_funenv_join
  (tid, fwork, env) = let
//
var tid2: pthread_t
var attr: pthread_attr_t
val
_(*err*) =
$extfcall(int, "pthread_attr_init", addr@attr)
//
val err =
$extfcall (
  int, "pthread_create"
, addr@tid2, addr@attr, fwork, $UN.castvwtp0{ptr}(env)
) (* end of [val] *)
val () = tid := $UN.cast2lint(tid2)
//
val _(*err*) = $extfcall (int, "pthread_attr_destroy", addr@attr)
//
in
  err
end // end of [athread_create_funenv]

implement{}
athread_join(tid) = {
val _(*err*) = $extfcall (int, "pthread_join", tid, $UN.castvwtp0{ptr}(0))
}

implement
{}(*tmp*)
athread_create_cloptr_join_exn
  (fwork) = tid where
{
//
var tid: lint
fun app
(
  f: () -<lincloptr1> void
): void = let
  val () = f () in cloptr_free($UN.castvwtp0{cloptr0}(f))
end // end of [app]
//
val f = $UN.castvwtp1{ptr}(fwork)
val err = athread_create_funenv_join<>(tid, app, fwork)
val () =
if (err != 0) then
{
//
val () = cloptr_free($UN.castvwtp0{cloptr0}(f))

val () =
fprintln! (
  stderr_ref, "libats/athread: [athread_create_cloptr_exn]: failed."
) (* end of [val] *)
//
} (* end of [if] *)
//
} (* end of [athread_create_cloptr_exn] *)