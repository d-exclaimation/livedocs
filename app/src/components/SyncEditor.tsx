//
//  SyncEditor.tsx
//  livedocs
//
//  Created by d-exclaimation on 16:13.
//

import React, { useCallback, useEffect, useRef, useState } from "react";
import ReactQuill from "react-quill";
import { useQueryParam } from "../hooks/useQueryParam";
import { enqueue } from "../utils/enqueue";

type Props = {};

const TOOLBAR_OPTIONS = [
  [{ header: [1, 2, 3, 4, 5, 6, false] }],
  [{ font: [] }],
  [{ list: "ordered" }, { list: "bullet" }],
  ["bold", "italic", "underline"],
  [{ color: [] }, { background: [] }],
  [{ script: "sub" }, { script: "super" }],
  [{ align: [] }],
  ["image", "blockquote", "code-block"],
  ["clean"],
];

const SyncEditor: React.FC<Props> = () => {
  const id = useQueryParam("id");
  const [value, setValue] = useState("");
  const socket = useRef<WebSocket | null>(null);
  const quillRef = useRef<ReactQuill | null>(null);

  const handler = useCallback(
    (ev: MessageEvent<any>) => {
      if (!quillRef.current) return;
      const data = JSON.parse(ev.data);
      const editor = quillRef.current.getEditor();
      editor.updateContents(data);
    },
    [quillRef]
  );

  useEffect(() => {
    socket.current = new WebSocket(`ws://localhost:4000/ws/${id ?? ""}`);
    enqueue(() => {
      if (!socket.current) return;
      // TODO: Update to set current state to it
      socket.current.onopen = () => setValue("Pee Pee");
      socket.current.onmessage = handler;
    });
    return () => {
      if (socket.current) socket.current.close();
    };
  }, [id, handler]);

  if (!id) {
    return null;
  }

  return (
    <ReactQuill
      ref={quillRef}
      modules={{ toolbar: TOOLBAR_OPTIONS }}
      value={value}
      theme="snow"
      onChange={(_, delta, source) => {
        if (source === "user") {
          socket.current?.send(JSON.stringify({ data: delta }));
        }
      }}
    />
  );
};

export default SyncEditor;
