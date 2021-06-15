import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import "./App.css";
import DocumentViewModel from "./components/DocumentViewModel";
import SyncEditor from "./components/SyncEditor";

const App: React.FC = () => {
  return (
    <Router>
      <Switch>
        <Route path="/" exact>
          <DocumentViewModel />
        </Route>
        <Route path="/docs" exact>
          <SyncEditor />
        </Route>
      </Switch>
    </Router>
  );
};

export default App;
