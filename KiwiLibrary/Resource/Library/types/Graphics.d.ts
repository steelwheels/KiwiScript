/// <reference path="Builtin.d.ts" />
/// <reference path="Math.d.ts" />
/// <reference path="Enum.d.ts" />
declare function addPoint(p0: PointIF, p1: PointIF): PointIF;
declare function isSamePoints(p0: PointIF, p1: PointIF): boolean;
declare function clampPoint(src: PointIF, x: number, y: number, width: number, height: number): PointIF;
