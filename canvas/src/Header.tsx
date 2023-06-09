import { HEADER_HEIGHT } from "./constants";

export const Header = () => {
  return (
    <div
      style={{
        position: "fixed",
        width: "100%",
        height: HEADER_HEIGHT,
        background: "#f7ede2",
        touchAction: "none",
        zIndex: 1,
      }}
    >
      Header
    </div>
  );
};
