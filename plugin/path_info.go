package fastly

import (
	"context"

	"github.com/barnumd/vault-fastly-secret-engine/version"
	"github.com/hashicorp/vault/logical"
	"github.com/hashicorp/vault/logical/framework"
)

func (b *backend) pathInfo(_ context.Context, req *logical.Request, _ *framework.FieldData) (*logical.Response, error) {
	return &logical.Response{
		Data: map[string]interface{}{
			"commit":  version.GitCommit,
			"version": version.Version,
		},
	}, nil
}
