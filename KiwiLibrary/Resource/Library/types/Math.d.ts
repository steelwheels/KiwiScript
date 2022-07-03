/// <reference path="Builtin.d.ts" />
/// <reference path="Enum.d.ts" />
interface Math {
    randomInt(min: number, max: number): number;
    clamp(src: number, min: number, max: number): number;
}
declare function int(value: number): number;
declare function compareNumbers(n0: number, n1: number): ComparisonResult;
declare function compareStrings(s0: string, s1: string): ComparisonResult;
