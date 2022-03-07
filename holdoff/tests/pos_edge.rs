use holdoff::PositiveEdgeHoldoff;

#[test]
fn a() {
    let mut h = PositiveEdgeHoldoff::new(10);
    assert_eq!(h.push(true, 0), Some(()));
    assert_eq!(h.push(false, 1), None);
    assert_eq!(h.push(false, 9), None);
    assert_eq!(h.push(true, 10), None);
    assert_eq!(h.push(false, 10), None);
    assert_eq!(h.push(true, 10), Some(()));
}
