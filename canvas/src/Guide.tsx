import React from "react";

const HorizontalLine = ({
  y,
  offsetY,
  scale,
  width,
}: {
  y: number;
  offsetY: number;
  scale: number;
  width: number;
}) => (
  <div
    style={{
      position: "fixed",
      left: 0,
      top: 0,
      transform: `translateY(${(y + offsetY) * scale}px)`,
      willChange: "transform",
      right: 0,
      height: 1,
    }}
  >
    <svg
      viewBox={`0 0 ${width} 2`}
      width={width}
      height="2"
      style={{ display: "block" }}
    >
      <line
        x1="0"
        y1="0"
        x2={width}
        y2="0"
        strokeWidth="2"
        stroke="#3a86ff"
        strokeDasharray="2"
      ></line>
    </svg>
  </div>
);

const VerticalLine = ({
  x,
  offsetX,
  scale,
  height,
}: {
  x: number;
  offsetX: number;
  scale: number;
  height: number;
}) => (
  <div
    style={{
      position: "absolute",
      left: 0,
      top: 0,
      transform: `translateX(${(x + offsetX) * scale}px)`,
      willChange: "transform",
      bottom: 0,
      width: 1,
    }}
  >
    <svg
      viewBox={`0 0 2 ${height}`}
      width="2"
      height={height}
      style={{ display: "block" }}
    >
      <line
        x1="0"
        y1="0"
        x2="0"
        y2={height}
        strokeWidth="2"
        stroke="#3a86ff"
        strokeDasharray="2"
      ></line>
    </svg>
  </div>
);

interface Props {
  scale: number;
  minX: number;
  minY: number;
  maxX: number;
  maxY: number;
  offsetY: number;
  offsetX: number;
  canvasWidth: number;
  canvasHeight: number;
}

export const Guide = ({
  scale,
  minX,
  minY,
  maxX,
  maxY,
  offsetY,
  offsetX,
  canvasWidth,
  canvasHeight,
}: Props) => {
  return (
    <>
      <HorizontalLine
        y={minY}
        offsetY={offsetY}
        scale={scale}
        width={canvasWidth}
      />
      <VerticalLine
        x={minX}
        offsetX={offsetX}
        scale={scale}
        height={canvasHeight}
      />
      <HorizontalLine
        y={maxY}
        offsetY={offsetY}
        scale={scale}
        width={canvasWidth}
      />
      <VerticalLine
        x={maxX}
        offsetX={offsetX}
        scale={scale}
        height={canvasHeight}
      />
    </>
  );
};
