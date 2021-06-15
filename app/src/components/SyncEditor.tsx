//
//  SyncEditor.tsx
//  livedocs
//
//  Created by d-exclaimation on 16:13.
//

import React, { useCallback, useEffect, useRef, useState } from "react";
import ReactQuill from "react-quill";
import { Delta, Sources } from "react-quill/node_modules/@types/quill";
import { useHistory } from "react-router-dom";
import { TOOLBAR_OPTIONS } from "../constants/quill";
import { __DOMAIN__ } from "../constants/uri";
import { useQueryParam } from "../hooks/useQueryParam";
import { saveRequest } from "../utils/api/request";
import { enqueue } from "../utils/enqueue";
import { parseEvent, parseOperation } from "../utils/parser/parseEvent";

const SyncEditor: React.FC = () => {
  const id = useQueryParam("id");
  const history = useHistory();
  const [isSaved, setSaved] = useState(true);
  const saveRef = useRef<number | NodeJS.Timeout | null>();
  const socket = useRef<WebSocket | null>(null);
  const quillRef = useRef<ReactQuill | null>(null);

  const saver = useCallback(() => {
    if (!quillRef.current || !id) return;
    const editor = quillRef.current.getEditor();
    saveRequest({
      value: editor.getContents(),
      id,
    });
    setSaved(true);
  }, [setSaved, id, quillRef]);

  const handler = useCallback(
    (ev: MessageEvent<string>) => {
      if (!quillRef.current) return;
      const [data, editor] = [parseEvent(ev), quillRef.current.getEditor()];
      switch (data.type) {
        case "operations":
          editor.updateContents(data.payload);
          return;
        case "init":
          editor.setContents(data.payload);
          return;
      }
    },
    [quillRef]
  );

  const changeHandler = useCallback(
    (_: string, delta: Delta, source: Sources) => {
      if (!socket.current || source !== "user") return;
      if (socket.current.readyState === socket.current.CLOSED)
        return history.go(0);
      if (saveRef.current) clearTimeout(saveRef.current as number);

      saveRef.current = setTimeout(saver, 2000);
      socket.current.send(parseOperation(delta));
      setSaved(false);
    },
    [socket, saveRef, setSaved, history, saver]
  );

  useEffect(() => {
    socket.current = new WebSocket(`ws://${__DOMAIN__}/ws/${id ?? ""}`);
    enqueue(() => {
      if (!socket.current) return;
      socket.current.onmessage = handler;
    });
    return () => {
      if (socket.current) socket.current.close();
      if (saveRef.current) clearTimeout(saveRef.current as number);
    };
  }, [id, handler]);

  if (!id) {
    return null;
  }

  return (
    <>
      <div
        className="App-link"
        style={{
          color: isSaved ? "#61dafb" : "#ff3361",
        }}
      >
        {isSaved ? "Saved" : "Not saved"}
      </div>
      <ReactQuill
        ref={quillRef}
        modules={{ toolbar: TOOLBAR_OPTIONS }}
        theme="snow"
        onChange={changeHandler}
      />
    </>
  );
};

export default SyncEditor;
