#![allow(dead_code)]

use std::cell::RefCell;
use std::fmt::Debug;
use std::ptr::NonNull;

use cc::{Cc, CcInner, Context, Trace};

#[derive(Debug)]
struct Node<T: Trace + Debug + 'static> {
    data: T,
    next: Option<Cc<RefCell<Node<T>>>>,
}

#[derive(Debug)]
struct TraceableString(String);

unsafe impl<T: Trace + Debug + 'static> Trace for Node<T> {
    unsafe fn trace(&self, ptrs: &mut Vec<NonNull<CcInner<dyn Trace>>>) {
        if let Some(next) = &self.next {
            next.trace(ptrs);
        }
    }
}

unsafe impl Trace for TraceableString {
    unsafe fn trace(&self, _: &mut Vec<NonNull<CcInner<dyn Trace>>>) {}
}

#[test]
fn test_cycle() {
    let mut context = Context::new();

    {
        let a = context.create(RefCell::new(Node {
            data: TraceableString("a".to_string()),
            next: None,
        }));

        let b = context.create(RefCell::new(Node {
            data: TraceableString("b".to_string()),
            next: None,
        }));

        let c = context.create(RefCell::new(Node {
            data: TraceableString("c".to_string()),
            next: None,
        }));

        a.borrow_mut().next = Some(Cc::clone(&b));
        b.borrow_mut().next = Some(Cc::clone(&c));
        c.borrow_mut().next = Some(Cc::clone(&a));
    }

    context.collect();

    assert_eq!(context.len(), 0);
}
