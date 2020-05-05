#include "../ats-pthread-ext.hats"
staload "libats/libc/SATS/unistd.sats"

implement main0() = {
    val id = athread_create_cloptr_join_exn(llam() => {
        val _ = sleep(2)
        val () = println!("Done")
    })
    val _ = athread_join(id)
    val () = println!("Really done")
}