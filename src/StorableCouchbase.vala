/*
 * StorableCouchbase.vala
 *
 * The Ambition Web Framework
 * http://www.ambitionframework.org
 *
 * Copyright 2012-2013 Sensical, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

using Gee;
namespace Ambition.Session {
	/**
	 * Store sessions in a Couchbase bucket.
	 */
	public class StorableCouchbase : Object,IStorable {
		private Couchbase.Client instance;

		public StorableCouchbase() throws Couchbase.ClientError {
			instance = Ambition.CouchbasePlugin.get_couchbase_instance();
		}

		public void store( string session_id, Interface i ) {
			var cb_session = new CouchbaseSession();
			cb_session.session_id = session_id;
			cb_session.session_data = i.serialize();
			bool success = false;
			success = instance.store_object(
				Couchbase.StoreMode.SET,
				session_id,
				cb_session
			);
			if (!success) {
				Logger.error("Unable to save session to Couchbase.");
			}
		}

		public Interface? retrieve( string session_id ) {
			var document = instance.get_object<CouchbaseSession>(session_id);
			if ( document != null ) {
				return new Interface.from_serialized( session_id, document.session_data );
			}
			return null;
		}
	}
}