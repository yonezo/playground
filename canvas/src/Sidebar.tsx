import { HEADER_HEIGHT, SIDEBAR_WIDTH } from "./constants";

export const Sidebar = () => {
  return (
    <div
      style={{
        position: "fixed",
        top: HEADER_HEIGHT,
        width: SIDEBAR_WIDTH,
        height: `calc(100vh - ${HEADER_HEIGHT}px)`,
        background: "#f7ede2",
        touchAction: "none",
        zIndex: 1,
      }}
    >
      Sidebar
    </div>
  );
};
