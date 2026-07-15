//
//  TabBarCurveShape.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

// MARK: - AnimatedNotchShape

/// A shape that reproduces the exact SVG tab-bar notch from the Figma design,
/// including edge cases where the notch merges with the left or right bar corner.
///
/// **Three path variants (same path structure — 10 curves + 5 lines):**
/// - **Center:** standard notch with separate corners on both sides.
/// - **Left edge (first tab):** the left corner merges with the notch via Bézier
///   curves from the Right-Edge SVG.
/// - **Right edge (last tab):** mirror — right corner merges with the notch via
///   curves from the Left-Edge SVG.
///
/// The `xAxis` parameter drives both horizontal notch position and edge-blend
/// factors. As `xAxis` approaches a bar edge, the path smoothly interpolates
/// between the center and edge geometries — no separate animation parameter is
/// needed.
struct AnimatedNotchShape: Shape {

    /// Horizontal center of the notch (in the parent's coordinate space).
    var xAxis: CGFloat

    var animatableData: CGFloat {
        get { xAxis }
        set { xAxis = newValue }
    }

    // MARK: – Shared geometry (center SVG)

    private static let cr: CGFloat = 32.0          // corner radius
    private static let nhw: CGFloat = 60.115       // notch half-width (to entry/exit)
    private static let nfl: CGFloat = -19.875      // notch flat-bottom left offset
    private static let nfr: CGFloat = 19.875       // notch flat-bottom right offset
    private static let nb: CGFloat = 40.25         // notch bottom Y
    private static let safe: CGFloat = 200.0       // safe-area bleed

    // Center notch Bézier offsets from xAxis (left side; mirror for right)
    private static let cnOuterX: CGFloat = -49.005
    private static let cnInnerX: CGFloat = -39.995
    private static let cnKneeX: CGFloat  = -30.985
    private static let cnMidY: CGFloat   = 20.12
    private static let cnMidY2: CGFloat  = 20.13
    private static let cnEntryY: CGFloat = 9.01
    private static let cnExitY: CGFloat  = 9.02
    private static let cnCpY1: CGFloat   = 31.23
    private static let cnCpY2: CGFloat   = 31.24

    // MARK: – Left-merge constants (Right-Edge SVG × 32/43.5)
    // Absolute X from bar left edge. For right-merge, mirror via W − x.

    // Merge curve 1: (0, cr) → m1e
    private static let m1e  = CGPoint(x: 3.10,  y: 18.25)
    private static let m1c1 = CGPoint(x: 0,     y: 27.08)
    private static let m1c2 = CGPoint(x: 1.11,  y: 22.42)

    // Merge curve 2: → m2e
    private static let m2e  = CGPoint(x: 11.39, y: 20.02)
    private static let m2c1 = CGPoint(x: 5.08,  y: 14.08)
    private static let m2c2 = CGPoint(x: 11.37, y: 15.42)

    // Tiny-vertical endpoint
    private static let mtvY: CGFloat = 20.13

    // Descent curve 1 (merge → notch bottom): → md1e
    private static let md1e  = CGPoint(x: 17.28, y: 34.36)
    private static let md1c1 = CGPoint(x: 11.39, y: 25.68)
    private static let md1c2 = CGPoint(x: 13.64, y: 30.72)

    // Descent curve 2: → ≈ (xAxis+nfl, nb)
    private static let md2c1 = CGPoint(x: 20.92, y: 38.00)
    private static let md2c2 = CGPoint(x: 25.95, y: 40.25)

    // MARK: – Edge notch 3-curve offsets from xAxis (Right-Edge SVG)
    // Positive = rightward. Negate & reverse order for left side.

    // Curve EN1 (bottom → mid): from (nfr, nb) → (e1eX, e1eY)
    private static let e1c1X: CGFloat = 30.95;  private static let e1c1Y: CGFloat = 40.25
    private static let e1c2X: CGFloat = 40.10;  private static let e1c2Y: CGFloat = 31.33
    private static let e1eX:  CGFloat = 40.02;  private static let e1eY:  CGFloat = 20.28

    // Curve EN2 (mid → upper): → (e2eX, e2eY)
    private static let e2c1X: CGFloat = 39.98;  private static let e2c1Y: CGFloat = 14.66
    private static let e2c2X: CGFloat = 42.24;  private static let e2c2Y: CGFloat = 9.58
    private static let e2eX:  CGFloat = 45.91;  private static let e2eY:  CGFloat = 5.89

    // Curve EN3 (upper → top): → (e3eX, 0)
    private static let e3c1X: CGFloat = 49.55;  private static let e3c1Y: CGFloat = 2.25
    private static let e3c2X: CGFloat = 54.58
    private static let e3eX:  CGFloat = 60.14

    // MARK: – Last-tab right-ascent offsets (Left-Edge SVG × 32/43.5)
    // These are tighter curves than the center because they feed into the merge.

    // Right ascent 1: from (nfr, nb) → (ra1eX, ra1eY)
    private static let ra1c1X: CGFloat = 25.39;  private static let ra1c1Y: CGFloat = 40.25
    private static let ra1c2X: CGFloat = 30.42;  private static let ra1c2Y: CGFloat = 38.00
    private static let ra1eX:  CGFloat = 33.98;  private static let ra1eY:  CGFloat = 34.36

    // Right ascent 2: → (ra2eX, ra2eY)
    private static let ra2c1X: CGFloat = 37.62;  private static let ra2c1Y: CGFloat = 30.72
    private static let ra2c2X: CGFloat = 40.00;  private static let ra2c2Y: CGFloat = 25.68
    private static let ra2eX:  CGFloat = 40.00;  private static let ra2eY:  CGFloat = 20.13

    // Right-merge offsets from W (for last tab, mirroring left-merge)
    private static let rm1eOff:  CGFloat = 11.49; private static let rm1eY:  CGFloat = 20.02
    private static let rm1c1Off: CGFloat = 11.47; private static let rm1c1Y: CGFloat = 15.42
    private static let rm1c2Off: CGFloat = 5.18;  private static let rm1c2Y: CGFloat = 14.08

    private static let rm2eOff:  CGFloat = 3.20;  private static let rm2eY:  CGFloat = 18.25
    private static let rm2c1Off: CGFloat = 1.21;  private static let rm2c1Y: CGFloat = 22.43
    private static let rm2c2Y:   CGFloat = 27.08

    // MARK: – Path construction

    func path(in rect: CGRect) -> Path {
        let W = rect.width
        let cr = Self.cr
        let nhw = Self.nhw
        let nb = Self.nb
        let nfl = Self.nfl
        let nfr = Self.nfr

        // ── Blend factors ──────────────────────────────────────────────
        // lb > 0 when notch overlaps left corner; rb > 0 for right.
        // They cannot both be > 0 simultaneously.
        let lb = min(1, max(0, (cr - (xAxis - nhw)) / cr))
        let rb = min(1, max(0, (cr - (W - xAxis - nhw)) / cr))

        // ── Helpers ────────────────────────────────────────────────────
        func lr(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat { a + (b - a) * t }
        func lp(_ a: CGPoint, _ b: CGPoint, _ t: CGFloat) -> CGPoint {
            CGPoint(x: lr(a.x, b.x, t), y: lr(a.y, b.y, t))
        }
        /// Pick the active blend: left-edge, right-edge, or center.
        func blend3(_ center: CGPoint, _ left: CGPoint, _ right: CGPoint) -> CGPoint {
            if lb > 0 { return lp(center, left, lb) }
            if rb > 0 { return lp(center, right, rb) }
            return center
        }
        func nx(_ off: CGFloat) -> CGFloat { xAxis + off }

        var path = Path()

        // ── Move: bottom-left ──────────────────────────────────────────
        path.move(to: CGPoint(x: 0, y: rect.height + Self.safe))

        // ── LINE 1: left edge up ───────────────────────────────────────
        path.addLine(to: CGPoint(x: 0, y: cr))

        // ── CURVE 1: left corner / left-merge curve 1 ─────────────────
        // Center: quarter-circle corner  (0,32)→(32,0)
        // First tab (lb): merge curve 1  (0,32)→(3.10,18.25)
        let c1e_c = CGPoint(x: cr, y: 0)
        let c1p1_c = CGPoint(x: 0, y: 14.33)
        let c1p2_c = CGPoint(x: 14.33, y: 0)
        path.addCurve(
            to:       lp(c1e_c,  Self.m1e,  lb),
            control1: lp(c1p1_c, Self.m1c1, lb),
            control2: lp(c1p2_c, Self.m1c2, lb)
        )

        // ── CURVE 2: degenerate / left-merge curve 2 ──────────────────
        let dg = CGPoint(x: cr, y: 0) // degenerate point
        path.addCurve(
            to:       lp(dg, Self.m2e,  lb),
            control1: lp(dg, Self.m2c1, lb),
            control2: lp(dg, Self.m2c2, lb)
        )

        // ── LINE 2: flat top / tiny vertical ──────────────────────────
        let l2_c = CGPoint(x: nx(-nhw), y: 0)
        let l2_e = CGPoint(x: Self.m2e.x, y: Self.mtvY)
        path.addLine(to: lp(l2_c, l2_e, lb))

        // ── CURVE 3: center notch-L1 / first-tab descent1 / last-tab edge-L1
        let c3e_c  = CGPoint(x: nx(Self.cnInnerX), y: Self.cnMidY)
        let c3p1_c = CGPoint(x: nx(Self.cnOuterX), y: 0)
        let c3p2_c = CGPoint(x: nx(Self.cnInnerX), y: Self.cnEntryY)

        let c3e_l  = Self.md1e
        let c3p1_l = Self.md1c1
        let c3p2_l = Self.md1c2

        // Last tab edge-L1 = reversed+mirrored EN3
        let c3e_r  = CGPoint(x: nx(-Self.e2eX),  y: Self.e2eY)
        let c3p1_r = CGPoint(x: nx(-Self.e3c2X), y: 0)
        let c3p2_r = CGPoint(x: nx(-Self.e3c1X), y: Self.e3c1Y)

        path.addCurve(
            to:       blend3(c3e_c,  c3e_l,  c3e_r),
            control1: blend3(c3p1_c, c3p1_l, c3p1_r),
            control2: blend3(c3p2_c, c3p2_l, c3p2_r)
        )

        // ── CURVE 4: center notch-L2 / first-tab descent2 / last-tab edge-L2
        let c4e_c  = CGPoint(x: nx(nfl), y: nb)
        let c4p1_c = CGPoint(x: nx(Self.cnInnerX), y: Self.cnCpY1)
        let c4p2_c = CGPoint(x: nx(Self.cnKneeX),  y: nb)

        let c4e_l  = CGPoint(x: nx(nfl), y: nb) // descent2 ends at notch flat left
        let c4p1_l = Self.md2c1
        let c4p2_l = Self.md2c2

        // Last tab edge-L2 = reversed+mirrored EN2
        let c4e_r  = CGPoint(x: nx(-Self.e1eX),  y: Self.e1eY)
        let c4p1_r = CGPoint(x: nx(-Self.e2c2X), y: Self.e2c2Y)
        let c4p2_r = CGPoint(x: nx(-Self.e2c1X), y: Self.e2c1Y)

        path.addCurve(
            to:       blend3(c4e_c,  c4e_l,  c4e_r),
            control1: blend3(c4p1_c, c4p1_l, c4p1_r),
            control2: blend3(c4p2_c, c4p2_l, c4p2_r)
        )

        // ── CURVE 5: degenerate / last-tab edge-L3 ────────────────────
        // Center & first-tab: degenerate at notch flat left
        let dg5 = CGPoint(x: nx(nfl), y: nb)

        // Last tab edge-L3 = reversed+mirrored EN1
        let c5e_r  = CGPoint(x: nx(nfl), y: nb) // ends at notch flat left
        let c5p1_r = CGPoint(x: nx(-Self.e1c2X), y: Self.e1c2Y)
        let c5p2_r = CGPoint(x: nx(-Self.e1c1X), y: nb)

        path.addCurve(
            to:       lp(dg5, c5e_r,  rb),
            control1: lp(dg5, c5p1_r, rb),
            control2: lp(dg5, c5p2_r, rb)
        )

        // ── LINE 3: notch flat bottom ──────────────────────────────────
        path.addLine(to: CGPoint(x: nx(nfr), y: nb))

        // ── CURVE 6: center notch-R1 / first-tab edge-R1 / last-tab ra1
        let c6e_c  = CGPoint(x: nx(-Self.cnInnerX), y: Self.cnMidY2)
        let c6p1_c = CGPoint(x: nx(-Self.cnKneeX),  y: nb)
        let c6p2_c = CGPoint(x: nx(-Self.cnInnerX), y: Self.cnCpY2)

        let c6e_l  = CGPoint(x: nx(Self.e1eX),  y: Self.e1eY)
        let c6p1_l = CGPoint(x: nx(Self.e1c1X), y: Self.e1c1Y)
        let c6p2_l = CGPoint(x: nx(Self.e1c2X), y: Self.e1c2Y)

        let c6e_r  = CGPoint(x: nx(Self.ra1eX),  y: Self.ra1eY)
        let c6p1_r = CGPoint(x: nx(Self.ra1c1X), y: Self.ra1c1Y)
        let c6p2_r = CGPoint(x: nx(Self.ra1c2X), y: Self.ra1c2Y)

        path.addCurve(
            to:       blend3(c6e_c,  c6e_l,  c6e_r),
            control1: blend3(c6p1_c, c6p1_l, c6p1_r),
            control2: blend3(c6p2_c, c6p2_l, c6p2_r)
        )

        // ── CURVE 7: center notch-R2 / first-tab edge-R2 / last-tab ra2
        let c7e_c  = CGPoint(x: nx(nhw),            y: 0)
        let c7p1_c = CGPoint(x: nx(-Self.cnInnerX), y: Self.cnExitY)
        let c7p2_c = CGPoint(x: nx(-Self.cnOuterX), y: 0)

        let c7e_l  = CGPoint(x: nx(Self.e2eX),  y: Self.e2eY)
        let c7p1_l = CGPoint(x: nx(Self.e2c1X), y: Self.e2c1Y)
        let c7p2_l = CGPoint(x: nx(Self.e2c2X), y: Self.e2c2Y)

        let c7e_r  = CGPoint(x: nx(Self.ra2eX),  y: Self.ra2eY)
        let c7p1_r = CGPoint(x: nx(Self.ra2c1X), y: Self.ra2c1Y)
        let c7p2_r = CGPoint(x: nx(Self.ra2c2X), y: Self.ra2c2Y)

        path.addCurve(
            to:       blend3(c7e_c,  c7e_l,  c7e_r),
            control1: blend3(c7p1_c, c7p1_l, c7p1_r),
            control2: blend3(c7p2_c, c7p2_l, c7p2_r)
        )

        // ── CURVE 8: degenerate / first-tab edge-R3 ───────────────────
        // Center & last-tab: degenerate at curve7 endpoint
        let dg8_c = CGPoint(x: nx(nhw), y: 0)
        let dg8_r = CGPoint(x: nx(Self.ra2eX), y: Self.ra2eY)
        let dg8   = lp(dg8_c, dg8_r, rb) // blended degenerate position

        let c8e_l  = CGPoint(x: nx(Self.e3eX),  y: 0)
        let c8p1_l = CGPoint(x: nx(Self.e3c1X), y: Self.e3c1Y)
        let c8p2_l = CGPoint(x: nx(Self.e3c2X), y: 0)

        path.addCurve(
            to:       lp(dg8, c8e_l,  lb),
            control1: lp(dg8, c8p1_l, lb),
            control2: lp(dg8, c8p2_l, lb)
        )

        // ── LINE 4: flat top right / tiny vertical ────────────────────
        let l4s_c = CGPoint(x: nx(nhw), y: 0)       // center start (same as curve8 center end)
        let l4e_c = CGPoint(x: W - cr, y: 0)         // center end
        let l4s_r = CGPoint(x: nx(Self.ra2eX), y: Self.ra2eY)
        let l4e_r = CGPoint(x: W - Self.rm1eOff, y: Self.rm1eY) // tiny vert end

        // When lb > 0, curve8 already moved the endpoint; line4 stays flat
        let l4e_l = CGPoint(x: W - cr, y: 0) // same as center
        // When rb > 0: line becomes tiny vertical (endpoint near right merge)
        let l4_end: CGPoint
        if rb > 0 {
            l4_end = lp(l4e_c, l4e_r, rb)
        } else {
            l4_end = l4e_c  // center or first-tab: flat top to right corner
        }
        path.addLine(to: l4_end)

        // ── CURVE 9: degenerate / right-merge curve 1 ─────────────────
        let dg9 = CGPoint(x: W - cr, y: 0)
        let c9e_r  = CGPoint(x: W - Self.rm2eOff,  y: Self.rm2eY)
        let c9p1_r = CGPoint(x: W - Self.rm1c1Off, y: Self.rm1c1Y)
        let c9p2_r = CGPoint(x: W - Self.rm1c2Off, y: Self.rm1c2Y)

        path.addCurve(
            to:       lp(dg9, c9e_r,  rb),
            control1: lp(dg9, c9p1_r, rb),
            control2: lp(dg9, c9p2_r, rb)
        )

        // ── CURVE 10: right corner / right-merge curve 2 ──────────────
        let c10e_c  = CGPoint(x: W,         y: cr)
        let c10p1_c = CGPoint(x: W - 14.33, y: 0)
        let c10p2_c = CGPoint(x: W,         y: 14.33)

        let c10e_r  = CGPoint(x: W,                  y: cr)
        let c10p1_r = CGPoint(x: W - Self.rm2c1Off,  y: Self.rm2c1Y)
        let c10p2_r = CGPoint(x: W,                  y: Self.rm2c2Y)

        path.addCurve(
            to:       lp(c10e_c,  c10e_r,  rb),
            control1: lp(c10p1_c, c10p1_r, rb),
            control2: lp(c10p2_c, c10p2_r, rb)
        )

        // ── LINE 5: right edge down ───────────────────────────────────
        path.addLine(to: CGPoint(x: W, y: rect.height + Self.safe))

        path.closeSubpath()
        return path
    }
}

// MARK: - Backward-compatible typealias

typealias TabBarCurveShape = AnimatedNotchShape
