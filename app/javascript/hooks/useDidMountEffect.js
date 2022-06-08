import React, {
  useEffect,
  useRef
} from "react";

export default function useDidMountEffect(func, dependencies) {
  const didMount = useRef(false);

  useEffect(() => {
    if (didMount.current) {
      func();
    } else {
      didMount.current = true;
    };
  }, dependencies);
};