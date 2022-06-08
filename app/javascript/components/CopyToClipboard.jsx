import React, {
  useRef,
  useState
} from "react";

import copy from "copy-to-clipboard";

export default function({ body }) {
  const inputRef = useRef(null);
  const [buttonText, setButtonText] = useState("Copy");

  function handleTextClick() {
    inputRef.current.select();

    copy(body);

    setButtonText("Copied!");
  };

  function handleCopyClick(event) {
    event.preventDefault();

    inputRef.current.select();

    copy(body);

    setButtonText("Copied!");
  };

  return (
    <div className="copy-to-clipboard">
      <input type="text"
             value={body}
             onClick={handleTextClick}
             ref={inputRef} />

      <a onClick={handleCopyClick}
         className="button button--small">{buttonText}</a>
    </div>
  );
};