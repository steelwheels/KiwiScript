declare enum AccessType {
  append = 2,
  read = 0,
  write = 1
}
declare namespace AccessType {
  function description(param: AccessType): string ;
  const keys: string[] ;
}
declare enum Alignment {
  center = 3,
  fill = 2,
  leading = 0,
  trailing = 1
}
declare namespace Alignment {
  function description(param: Alignment): string ;
  const keys: string[] ;
}
declare enum AnimationState {
  idle = 0,
  pause = 2,
  run = 1
}
declare namespace AnimationState {
  function description(param: AnimationState): string ;
  const keys: string[] ;
}
declare enum Authorize {
  authorized = 3,
  denied = 2,
  undetermined = 0
}
declare namespace Authorize {
  function description(param: Authorize): string ;
  const keys: string[] ;
}
declare enum Axis {
  horizontal = 0,
  vertical = 1
}
declare namespace Axis {
  function description(param: Axis): string ;
  const keys: string[] ;
}
declare enum Distribution {
  equalSpacing = 3,
  fill = 0,
  fillEqually = 2,
  fillProportinally = 1
}
declare namespace Distribution {
  function description(param: Distribution): string ;
  const keys: string[] ;
}
declare enum ExitCode {
  commaneLineError = 2,
  exception = 4,
  internalError = 1,
  noError = 0,
  syntaxError = 3
}
declare namespace ExitCode {
  function description(param: ExitCode): string ;
  const keys: string[] ;
}
declare enum FileType {
  directory = 2,
  file = 1,
  notExist = 0
}
declare namespace FileType {
  function description(param: FileType): string ;
  const keys: string[] ;
}
declare enum FontSize {
  large = 19,
  regular = 13,
  small = 11
}
declare namespace FontSize {
  function description(param: FontSize): string ;
  const keys: string[] ;
}
declare enum LogLevel {
  debug = 3,
  detail = 4,
  error = 1,
  nolog = 0,
  warning = 2
}
declare namespace LogLevel {
  function description(param: LogLevel): string ;
  const keys: string[] ;
}
declare enum TextAlign {
  center = 2,
  justfied = 3,
  left = 0,
  normal = 4,
  right = 1
}
declare namespace TextAlign {
  function description(param: TextAlign): string ;
  const keys: string[] ;
}
declare enum ValueType {
  URLType = 13,
  arrayType = 11,
  boolType = 1,
  colorType = 14,
  dateType = 4,
  dictionaryType = 10,
  enumType = 9,
  imageType = 15,
  nullType = 0,
  numberType = 2,
  objectType = 17,
  pointType = 6,
  rangeType = 5,
  recordType = 16,
  rectType = 8,
  segmentType = 18,
  sizeType = 7,
  stringType = 3
}
declare namespace ValueType {
  function description(param: ValueType): string ;
  const keys: string[] ;
}
