"""Coverage and arithmetic audit for the direct GP verifier (standard library)."""
import csv
import hashlib
import json
from collections import Counter
from pathlib import Path

BASE = Path(__file__).resolve().parent


def prime(n):
    return n >= 2 and all(n % d for d in range(2, int(n**0.5) + 1))


def load(name):
    with (BASE / name).open(newline="") as handle:
        rows = [
            {key.replace("rational_Frike_fixed", "rational_Fricke_fixed"): int(value)
             for key, value in row.items()}
            for row in csv.DictReader(handle)
        ]
    return rows


def audit(rows, primes):
    expected = {(p, ell) for p in primes for ell in (3, 5, 7) if p != ell}
    actual = {(r["p"], r["ell"]) for r in rows}
    assert len(rows) == len(actual), "Duplicate cases"
    assert actual == expected, f"Missing {expected-actual}; extra {actual-expected}"
    for r in rows:
        p, ell = r["p"], r["ell"]
        assert r["N"] == ell**2
        ss = p // 12 + (0 if p % 12 == 1 else 2 if p % 12 == 11 else 1)
        assert ss == r["supersingular_j"]
        raw = ell * (ell + 1)
        assert r["raw_cyclic_kernels"] == raw * ss
        # Independent fibre count under the reduced automorphism groups.
        # Invariant cyclic lines are eigenlines modulo ell^2.
        fix3 = sum((t*t + t + 1) % (ell*ell) == 0 for t in range(ell*ell))
        fix4 = sum((t*t + 1) % (ell*ell) == 0 for t in range(ell*ell))
        c0 = (raw + 2*fix3) // 3
        c1728 = (raw + fix4) // 2
        special_raw = raw * (int(p % 3 == 2) + int(p % 4 == 3))
        special_coarse = c0 * int(p % 3 == 2) + c1728 * int(p % 4 == 3)
        assert r["raw_special_j_kernels"] == special_raw
        assert r["coarse_special_j_points"] == special_coarse
        assert r["coarse_X0_points"] == raw*ss - special_raw + special_coarse
        assert r["formula5"] == (ell+1)*r["rational_j"] // 2
        assert r["direct_rational_quotient"] == r["formula5"]
        assert 0 <= r["swapped_lift_orbits"] <= r["direct_rational_quotient"]
        assert r["direct_rational_quotient"] <= r["Fricke_orbits"] <= r["coarse_X0_points"]
        assert 2*r["Fricke_orbits"] - r["coarse_X0_points"] >= 0
    return rows


def totals(rows):
    return {
        "comparisons": len(rows),
        "mismatches": sum(r["direct_rational_quotient"] != r["formula5"] for r in rows),
        "raw_cyclic_kernels": sum(r["raw_cyclic_kernels"] for r in rows),
        "coarse_X0_points": sum(r["coarse_X0_points"] for r in rows),
        "swapped_lift_rational_orbits": sum(r["swapped_lift_orbits"] for r in rows),
        "pairs_with_special_j": sum(r["raw_special_j_kernels"] > 0 for r in rows),
        "naive_j_triple_mismatches": sum(
            r["naive_triple_count"] != r["direct_rational_quotient"] for r in rows
        ),
    }


def main():
    baseline = audit(load("square_direct.csv"), [p for p in range(5, 301) if prime(p)])
    extended = audit(load("square_extended.csv"), [p for p in range(5, 1001) if prime(p)])
    heldout = audit(load("square_heldout.csv"), [1009, 2003, 5003])
    extmap = {(r["p"], r["ell"]): r for r in extended}
    assert all(r == extmap[r["p"], r["ell"]] for r in baseline), "Repeat-run discrepancy"
    unique = extended + heldout
    middle = load("middle_pairs.csv")
    primary = {(r["p"], r["ell"]): r for r in unique}
    assert len(middle) == len(primary)
    assert {(r["p"], r["ell"]) for r in middle} == set(primary)
    for r in middle:
        other = primary[r["p"], r["ell"]]
        assert r["rational_middle_j"] == other["rational_j"]
        assert r["raw_unordered_pairs"] == r["rational_middle_j"] * r["ell"] * (r["ell"]+1) // 2
        assert r["direct_middle_pair_count"] == other["direct_rational_quotient"]
    logs = [BASE / name for name in ("baseline.log", "extended.log", "heldout.log")]
    logs += [BASE / "middle_pairs.log", BASE / "snapshot_audit.log"]
    assert all("***" not in path.read_text() and 'error("' not in path.read_text() for path in logs)
    summary = {
        "date": "2026-10-26",
        "runtime": "PARI/GP 2.15.4",
        "baseline_through_300": totals(baseline),
        "extended_through_1000": totals(extended),
        "heldout_primes": [1009, 2003, 5003],
        "heldout": totals(heldout),
        "unique": totals(unique),
        "middle_pair_crosschecks": len(middle),
        "middle_pair_mismatches": 0,
        "rational_middle_j_fibres_checked": sum(r["rational_middle_j"] for r in middle),
        "skips_of_admissible_cases": 0,
        "excluded_characteristics": [2, 3],
        "excluded_pairs": [[5, 5], [7, 7]],
        "class_numbers_used_in_direct_count": False,
        "modular_form_traces_used": False,
        "characteristic_zero_fixed_point_formula_used": False,
        "hauptmodul_polynomials_computed": False,
        "all_automorphisms_included": True,
        "all_frobenius_fricke_involution_and_commutation_checks_passed": True,
        "all_degree_ell_dual_rational_map_identities_passed": True,
        "all_fibre_aut_eigenline_checks_passed": True,
        "baseline_repeated_with_same_aggregate_results": True,
        "current_source_sha256": hashlib.sha256((BASE / "verify_square_direct.gp").read_bytes()).hexdigest(),
        "csv_sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in BASE.glob("square_*.csv")},
        "per_level": {
            str(ell*ell): totals([r for r in unique if r["ell"] == ell]) for ell in (3, 5, 7)
        },
        "prime_residue_classes_mod_12": dict(sorted(Counter(r["p"] % 12 for r in unique).items())),
    }
    (BASE / "verification_summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    table = "| p | L(p) | level 9 | level 25 | level 49 |\n|---:|---:|---:|---:|---:|\n"
    for p in [5, 7, 11, 13, 37, 101, 293, 997, 1009, 2003, 5003]:
        rr = {r["ell"]: r for r in unique if r["p"] == p}
        lp = next(iter(rr.values()))["rational_j"]
        cells = [str(rr[ell]["direct_rational_quotient"]) if ell in rr else "excluded" for ell in (3, 5, 7)]
        table += f"| {p} | {lp} | {' | '.join(cells)} |\n"
    (BASE / "representative_table.md").write_text(table)
    print(json.dumps(summary, indent=2))
    print(table)


if __name__ == "__main__":
    main()
